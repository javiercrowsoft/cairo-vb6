if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ParteDiarioGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ParteDiarioGet]

go

create procedure sp_ParteDiarioGet (
	@@ptd_id int
)
as

begin

	set nocount on

	declare @doct_id 				int
	declare @doc_id					int
	declare @doc_descrip		varchar(255)

	select @doct_id = doct_id, @doc_id = doc_id from ParteDiario where ptd_id = @@ptd_id

  if @doct_id in (1,7,9) begin
    
		select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),fv_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),fv_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),fv_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + fv_descrip


		from facturaventa fv inner join documentotipo doct on fv.doct_id = doct.doct_id 
												 inner join cliente cli        on fv.cli_id  = cli.cli_id
                         inner join condicionpago cpg  on fv.cpg_id  = cpg.cpg_id
		where fv_id = @doc_id

		goto select_rslt

	end 

--///////////////////////////////
--
-- FACTURAS DE COMPRA
--
--///////////////////////////////

  if @doct_id in (2,8,10) begin
    
    select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),fc_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),fc_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),fc_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + fc_descrip


		from facturacompra fc inner join documentotipo doct on fc.doct_id = doct.doct_id 
													inner join proveedor prov     on fc.prov_id = prov.prov_id
                          inner join condicionpago cpg  on fc.cpg_id  = cpg.cpg_id
		where fc_id = @doc_id

		goto select_rslt

	end 

--///////////////////////////////
--
-- REMITOS DE COMPRA
--
--///////////////////////////////

  if @doct_id in (4,25) begin
    
    select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),rc_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),rc_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),rc_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + rc_descrip


		from remitocompra rc  inner join documentotipo doct on rc.doct_id = doct.doct_id 
													inner join proveedor prov     on rc.prov_id = prov.prov_id
                          inner join condicionpago cpg  on rc.cpg_id  = cpg.cpg_id
		where rc_id = @doc_id

		goto select_rslt

	end 

--///////////////////////////////
--
-- ORDENES DE COMPRA
--
--///////////////////////////////

  if @doct_id in (35,36) begin
    
    select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),oc_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),oc_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),oc_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + oc_descrip


		from ordencompra oc 	inner join documentotipo doct on oc.doct_id = doct.doct_id 
													inner join proveedor prov     on oc.prov_id = prov.prov_id
                          inner join condicionpago cpg  on oc.cpg_id  = cpg.cpg_id
		where oc_id = @doc_id

		goto select_rslt

	end 

--///////////////////////////////
--
-- PEDIDOS DE COMPRA
--
--///////////////////////////////

  if @doct_id in (6,23) begin
    
    select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),pc_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),pc_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),pc_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + pc_descrip


		from pedidocompra pc 	inner join documentotipo doct on pc.doct_id = doct.doct_id 
													inner join usuario us     		on pc.us_id = us.us_id
		where pc_id = @doc_id

		goto select_rslt

	end 

--///////////////////////////////
--
-- REMITOS DE VENTA
--
--///////////////////////////////

  if @doct_id in (3,24) begin
    
		select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),rv_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),rv_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),rv_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + rv_descrip


		from remitoventa rv 	inner join documentotipo doct on rv.doct_id = doct.doct_id 
												  inner join cliente cli        on rv.cli_id  = cli.cli_id
                          inner join condicionpago cpg  on rv.cpg_id  = cpg.cpg_id
		where rv_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- PEDIDOS DE VENTA
--
--///////////////////////////////

  if @doct_id in (5,22) begin
    
		select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),pv_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),pv_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),pv_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + pv_descrip


		from pedidoventa pv 	inner join documentotipo doct on pv.doct_id = doct.doct_id 
												  inner join cliente cli        on pv.cli_id  = cli.cli_id
                          inner join condicionpago cpg  on pv.cpg_id  = cpg.cpg_id
		where pv_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- ORDEN DE SERVICIO
--
--///////////////////////////////

  if @doct_id = 42 begin
    
		select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),os_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),os_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),os_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + os_descrip


		from ordenservicio os inner join documentotipo doct on os.doct_id = doct.doct_id 
												  inner join cliente cli        on os.cli_id  = cli.cli_id
                          inner join condicionpago cpg  on os.cpg_id  = cpg.cpg_id
		where os_id = @doc_id

		goto select_rslt

	end 

--///////////////////////////////
--
-- PARTE DE REPARACION
--
--///////////////////////////////

  if @doct_id = 43 begin
    
		select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),prp_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),prp_total)) + char(13) +
						'Observaciones     ' + char(13) + prp_descrip


		from partereparacion prp inner join documentotipo doct on prp.doct_id = doct.doct_id 
												 		 inner join cliente cli        on prp.cli_id  = cli.cli_id
                         		 inner join condicionpago cpg  on prp.cpg_id  = cpg.cpg_id
		where prp_id = @doc_id

		goto select_rslt

	end 

--///////////////////////////////
--
-- PRESUPUESTOS DE VENTA
--
--///////////////////////////////

  if @doct_id in (11,39) begin
    
		select 	@doc_descrip =
						'Condicion de Pago ' + cpg_nombre + char(13) +
						'Fecha             ' + convert(varchar(12),prv_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),prv_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),prv_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + prv_descrip


		from presupuestoventa prv 	inner join documentotipo doct on prv.doct_id = doct.doct_id 
												  			inner join cliente cli        on prv.cli_id  = cli.cli_id
                          			inner join condicionpago cpg  on prv.cpg_id  = cpg.cpg_id
		where prv_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- COBRANZAS
--
--///////////////////////////////

  if @doct_id = 13 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),cobz_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),cobz_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),cobz_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + cobz_descrip


		from cobranza cobz 	inner join documentotipo doct on cobz.doct_id = doct.doct_id 
								  			inner join cliente cli        on cobz.cli_id  = cli.cli_id
		where cobz_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- ORDENES DE PAGO
--
--///////////////////////////////

  if @doct_id = 16 begin
    
    select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),opg_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),opg_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),opg_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + opg_descrip


		from ordenpago opg inner join documentotipo doct on opg.doct_id = doct.doct_id 
											 inner join proveedor prov     on opg.prov_id = prov.prov_id
		where opg_id = @doc_id

		goto select_rslt

	end 

--///////////////////////////////
--
-- MOVIMIENTO DE FONDOS
--
--///////////////////////////////

  if @doct_id = 26 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),mf_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),mf_total)) + char(13) +
						'Pendiente         ' + convert(varchar,convert(decimal(18,2),mf_pendiente)) + char(13) +
						'Observaciones     ' + char(13) + mf_descrip


		from movimientofondo mf inner join documentotipo doct on mf.doct_id = doct.doct_id 
								  					inner join cliente cli        on mf.cli_id  = cli.cli_id
		where mf_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- DEPOSITO BANCO
--
--///////////////////////////////

  if @doct_id = 17 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),dbco_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),dbco_total)) + char(13) +
						'Observaciones     ' + char(13) + dbco_descrip


		from depositobanco dbco inner join documentotipo doct on dbco.doct_id = doct.doct_id 
								  					inner join banco bco        	on dbco.bco_id  = bco.bco_id
		where dbco_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- STOCK
--
--///////////////////////////////

  if @doct_id = 14 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),st_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + st_descrip


		from stock st inner join documentotipo doct on st.doct_id = doct.doct_id 
			  					inner join depositologico d1 	on st.depl_id_origen  = d1.depl_id
			  					inner join depositologico d2 	on st.depl_id_destino = d2.depl_id
		where st_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- PARTE DE PRODUCCION
--
--///////////////////////////////

  if @doct_id in (30,34) begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),ppk_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + ppk_descrip


		from parteprodkit ppk inner join documentotipo doct  on ppk.doct_id = doct.doct_id 
			  									inner join depositologico depl on ppk.depl_id = depl.depl_id
		where ppk_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- RECUENTO DE STOCK
--
--///////////////////////////////

  if @doct_id = 38 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),rs_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + rs_descrip


		from recuentostock rs inner join documentotipo doct  on rs.doct_id = doct.doct_id 
			  									inner join depositologico depl on rs.depl_id = depl.depl_id
		where rs_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- STOCK A PROVEEDOR
--
--///////////////////////////////

  if @doct_id = 44 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),stprov_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + stprov_descrip


		from stockproveedor stprov 	inner join documentotipo doct on stprov.doct_id = doct.doct_id 
										  					inner join depositologico d1 	on stprov.depl_id_origen  = d1.depl_id
										  					inner join depositologico d2 	on stprov.depl_id_destino = d2.depl_id
																inner join proveedor prov     on stprov.prov_id = prov.prov_id
		where stprov_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- STOCK A CLIENTE
--
--///////////////////////////////

  if @doct_id = 45 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),stcli_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + stcli_descrip


		from stockcliente stcli 	  inner join documentotipo doct on stcli.doct_id = doct.doct_id 
										  					inner join depositologico d1 	on stcli.depl_id_origen  = d1.depl_id
										  					inner join depositologico d2 	on stcli.depl_id_destino = d2.depl_id
															 	inner join cliente cli        on stcli.cli_id  = cli.cli_id
		where stcli_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- TAREA
--
--///////////////////////////////

  if @doct_id = 2007 begin
    
		select 	@doc_descrip =
						'Fecha Inicio      ' + convert(varchar(12),tar_fechaini,101) + char(13) +
						'Fecha Fin         ' + convert(varchar(12),tar_fechafin,101) + char(13) +
						'Observaciones     ' + char(13) + tar_descrip


		from tarea tar 	inner join proyecto proy 			on tar.proy_id  = proy.proy_id
				  					left  join proyectoitem proyi on tar.proyi_id = proyi.proyi_id
									 	left  join cliente cli    		on tar.cli_id   = cli.cli_id
		where tar_id = @doc_id

		goto select_rslt

	end


--///////////////////////////////
--
-- HORA
--
--///////////////////////////////

  if @doct_id = 2006 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),hora_fecha,101) + char(13) +
						'Hora Desde        ' + convert(varchar(12),hora_desde,101) + char(13) +
						'Hora Hasta        ' + convert(varchar(12),hora_hasta,101) + char(13) +
						'Observaciones     ' + char(13) + hora_descrip


		from hora hr 	inner join proyecto proy 			on hr.proy_id  = proy.proy_id
									left  join tarea tar          on hr.tar_id   = tar.tar_id
			  					left  join proyectoitem proyi on hr.proyi_id = proyi.proyi_id
								 	left  join cliente cli    		on hr.cli_id   = cli.cli_id
		where hora_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- PRODUCTO NUMERO SERIE
--
--///////////////////////////////

  if @doct_id = 1017 begin
    
		select 	@doc_descrip =
						'Fecha Vto         ' + convert(varchar(12),prns_fechavto,101) + char(13) +
						'Observaciones     ' + char(13) + prns_descrip


		from productonumeroserie prns inner join producto pr 		on prns.pr_id  = pr.pr_id 
								  								left  join stocklote stl  on prns.stl_id = stl.stl_id
		where prns_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- CALCULO DE DESPACHOS DE IMPORTACION
--
--///////////////////////////////

  if @doct_id = 1702 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),dic_fecha,101) + char(13) +
						'Total             ' + convert(varchar,convert(decimal(18,2),dic_total)) + char(13) +
						'Observaciones     ' + char(13) + dic_descrip


		from DespachoImpCalculo dic inner join remitocompra rc    on dic.rc_id = rc.rc_id
																inner join proveedor prov     on rc.prov_id = prov.prov_id
		where dic_id = @doc_id

		goto select_rslt

	end

--///////////////////////////////
--
-- LEGAJO
--
--///////////////////////////////

  if @doct_id = 15001 begin
    
		select 	@doc_descrip =
						'Fecha             ' + convert(varchar(12),lgj_fecha,101) + char(13) +
						'Observaciones     ' + char(13) + lgj_descrip


		from legajo lgj left join cliente cli on lgj.cli_id  = cli.cli_id
		where lgj_id = @doc_id

		goto select_rslt

	end

select_rslt:

  select   
					ptd.*,  
					ua.us_nombre as asignador,  
					ur.us_nombre as responsable,  
					contacto.cont_nombre,  
					prioridad.prio_nombre,  
					cliente.cli_nombre,  
					prov_nombre,
					case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,  
					tareaestado.tarest_nombre,
					doct_nombre,

					case 
						when ptd.doct_id in (1,7,9) 	and doc_id is not null then (select fv_nrodoc 		from facturaventa 				where fv_id = ptd.doc_id)
						when ptd.doct_id in (2,8,10) 	and doc_id is not null then (select fc_nrodoc 		from facturacompra 				where fc_id = ptd.doc_id)  
					  when ptd.doct_id in (4,25) 		and doc_id is not null then (select rc_nrodoc 		from remitocompra 				where rc_id = ptd.doc_id)  
					  when ptd.doct_id in (35,36) 	and doc_id is not null then (select oc_nrodoc 		from ordencompra 					where oc_id = ptd.doc_id)  
					  when ptd.doct_id in (6,23) 		and doc_id is not null then (select pc_nrodoc 		from pedidocompra 				where pc_id = ptd.doc_id)  
					  when ptd.doct_id in (3,24) 		and doc_id is not null then (select rv_nrodoc 		from remitoventa 					where rv_id = ptd.doc_id)  
					  when ptd.doct_id in (5,22) 		and doc_id is not null then (select pv_nrodoc 		from pedidoventa 					where pv_id = ptd.doc_id)  
					  when ptd.doct_id = 42 				and doc_id is not null then (select os_nrodoc 		from ordenservicio 				where os_id = ptd.doc_id)  
					  when ptd.doct_id = 43 				and doc_id is not null then (select prp_nrodoc 		from partereparacion 			where prp_id = ptd.doc_id)  
					  when ptd.doct_id in (11,39) 	and doc_id is not null then (select prv_nrodoc 		from presupuestoventa 		where prv_id = ptd.doc_id)  
					  when ptd.doct_id = 13 				and doc_id is not null then (select cobz_nrodoc 	from cobranza 						where cobz_id = ptd.doc_id)  
					  when ptd.doct_id = 16 				and doc_id is not null then (select opg_nrodoc 		from ordenpago 						where opg_id = ptd.doc_id)  
					  when ptd.doct_id = 26 				and doc_id is not null then (select mf_nrodoc 		from movimientofondo 			where mf_id = ptd.doc_id)  
					  when ptd.doct_id = 17 				and doc_id is not null then (select dbco_nrodoc 	from depositobanco 				where dbco_id = ptd.doc_id)  
					  when ptd.doct_id = 14 				and doc_id is not null then (select st_nrodoc 		from stock 								where st_id = ptd.doc_id)  
					  when ptd.doct_id in (30,34) 	and doc_id is not null then (select ppk_nrodoc 		from parteprodkit   			where ppk_id = ptd.doc_id)  
					  when ptd.doct_id = 38 				and doc_id is not null then (select rs_nrodoc 		from recuentostock 				where rs_id = ptd.doc_id)  
					  when ptd.doct_id = 44 				and doc_id is not null then (select stprov_nrodoc from stockproveedor 			where stprov_id = ptd.doc_id)  
					  when ptd.doct_id = 45 				and doc_id is not null then (select stcli_nrodoc 	from stockcliente 				where stcli_id = ptd.doc_id)  
					  when ptd.doct_id = 2007 			and doc_id is not null then (select tar_numero 		from tarea 								where tar_id = ptd.doc_id)  
					  when ptd.doct_id = 2006 			and doc_id is not null then (select hora_titulo 	from hora 								where hora_id = ptd.doc_id)  
					  when ptd.doct_id = 1017 			and doc_id is not null then (select prns_codigo 	from productonumeroserie 	where prns_id = ptd.doc_id)  
					  when ptd.doct_id = 1702 			and doc_id is not null then (select rc_nrodoc     from despachoimpcalculo dic inner join remitocompra rc on dic.rc_id = rc.rc_id where dic_id = ptd.doc_id)  
					  when ptd.doct_id = 15001 			and doc_id is not null then (select lgj_codigo 		from legajo 							where lgj_id = ptd.doc_id)  
					
					end as doc_nro,

					prs_apellido +', '+ prs_nombre as alum_nombre,
					
					@doc_descrip as doc_descrip
  from   
     partediario as ptd left join usuario as ua 	on ptd.us_id_asignador   = ua.us_id  
                        left join usuario as ur 	on ptd.us_id_responsable = ur.us_id  
                        left join contacto      	on ptd.cont_id           = contacto.cont_id  
                        left join prioridad     	on ptd.prio_id           = prioridad.prio_id  
                        left join cliente       	on ptd.cli_id            = cliente.cli_id  
                        left join proveedor prov  on ptd.prov_id           = prov.prov_id
                        left join legajo        	on ptd.lgj_id            = legajo.lgj_id  
                        left join tareaestado   	on ptd.tarest_id         = tareaestado.tarest_id  
												left join alumno alum     on ptd.alum_id           = alum.alum_id
												left join persona prs     on alum.prs_id           = prs.prs_id

												left join DocumentoTipo doct on ptd.doct_id = doct.doct_id

  where ptd_id = @@ptd_id


end

GO
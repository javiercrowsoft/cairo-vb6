/*---------------------------------------------------------------------
Nombre: Saldo de Disponibilidades
---------------------------------------------------------------------*/
/*

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_TSR_0210]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_TSR_0210]

-- exec [DC_CSC_TSR_0210] 3,'20091231 00:00:00','N82854',0

go
create procedure DC_CSC_TSR_0210 (

  @@us_id    int,
	@@Ffin 		 datetime,

	@@cue_id 	 						varchar(255),
	@@resumido						smallint

)as 

begin

set nocount on

declare @cue_id 					int
declare @ram_id_cuenta 		int

declare @clienteID 		int
declare @IsRaiz    		tinyint

exec sp_ArbConvertId @@cue_id, @cue_id out, @ram_id_cuenta out

exec sp_GetRptId @clienteID out

if @ram_id_cuenta <> 0 begin

--	exec sp_ArbGetGroups @ram_id_cuenta, @clienteID, @@us_id

	exec sp_ArbIsRaiz @ram_id_cuenta, @IsRaiz out
  if @IsRaiz = 0 begin
		exec sp_ArbGetAllHojas @ram_id_cuenta, @clienteID 
	end else 
		set @ram_id_cuenta = 0
end

/*- ///////////////////////////////////////////////////////////////////////

SEGURIDAD SOBRE USUARIOS EXTERNOS

/////////////////////////////////////////////////////////////////////// */

declare @us_empresaEx tinyint
select @us_empresaEx = us_empresaEx from usuario where us_id = @@us_id	

/*- ///////////////////////////////////////////////////////////////////////

CODIGO DEL REPORTE

/////////////////////////////////////////////////////////////////////// */

	create table #t_dc_csc_tsr_0210 (

																		tipo				tinyint,
																		pr_id				int,
																		doct_id			int,
																		comp_id			int,
																		mon_id      int,
																		cotizacion	decimal(18,6) not null default(0),
																		saldoorigen	decimal(18,6) not null default(0),
																		saldo				decimal(18,6) not null default(0),
																		cuenta			varchar(255)
																		
																	)



--/////////////////////////////////////////////////////////////////////////
		declare @hoy 					datetime
		declare @cotiz  			decimal(18,6)
		declare @mon_legal		int
		declare @mon_id       int
	
		set @hoy = getdate()
		set @hoy = dateadd(hh,-datepart(hh,@hoy),@hoy)
		set @hoy = dateadd(n,-datepart(n,@hoy),@hoy)
		set @hoy = dateadd(s,-datepart(s,@hoy),@hoy)
		set @hoy = dateadd(ms,-datepart(ms,@hoy),@hoy)
		
		create table #t_cotizacion (
																	mon_id			int,
																	cotizacion	decimal(18,6)
																)

		declare c_monedas insensitive cursor for select mon_id from Moneda where mon_legal = 0

		open c_monedas

		fetch next from c_monedas into @mon_id
		while @@fetch_status = 0
		begin

			exec sp_MonedaGetCotizacion @mon_id, @hoy, 0, @cotiz out

			insert into #t_cotizacion (mon_id, cotizacion) values (@mon_id, @cotiz)

			fetch next from c_monedas into @mon_id
		end

		close c_monedas
		deallocate c_monedas

		select @mon_legal = mon_id from Moneda where mon_legal <> 0

		insert into #t_cotizacion (mon_id, cotizacion) values (@mon_legal, 1)

--/////////////////////////////////////////////////////////////////////////

/*- ///////////////////////////////////////////////////////////////////////

CUENTAS

/////////////////////////////////////////////////////////////////////// */

	-- Saldo Inicial

	insert into #t_dc_csc_tsr_0210 (tipo, saldo, cuenta, mon_id, saldoorigen, cotizacion)

		select 
					1,
					
					sum(case when cue.mon_id <> @mon_legal 
									 then 
													case when asi_debe <> 0 then asi_origen 
															 else -asi_origen 
													end 
									 else 
													case when asi_debe <> 0 then asi_debe
															 else -asi_haber
													end 
							end				) * coti.cotizacion,

					case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre end,
					cue.mon_id,
					sum(case when asi_debe <> 0 then asi_origen else -asi_origen end),
					coti.cotizacion

		from
		
					AsientoItem asi inner join Asiento ast on asi.as_id = ast.as_id
													inner join Documento doc on ast.doc_id = doc.doc_id		
													inner join Cuenta cue on asi.cue_id = cue.cue_id
													inner join Moneda mon on cue.mon_id = mon.mon_id
													left  join #t_cotizacion coti on cue.mon_id = coti.mon_id
	
		where 
						  as_fecha <= @@Ffin
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		and   (asi.cue_id = @cue_id or @cue_id=0)
		and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = asi.cue_id)) or (@ram_id_cuenta = 0))
		
		group by case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre end,
						 coti.cotizacion, cue.mon_id

	-- Entre fechas

-- 	insert into #t_dc_csc_tsr_0210 (tipo, doct_id, comp_id, saldo, cuenta, mon_id, saldoorigen, cotizacion)
-- 
-- 		select 
-- 					2,
-- 					ast.doct_id,					
-- 					asi.as_id, 
-- 					sum(case when cue.mon_id <> @mon_legal 
-- 									 then 
-- 													case when asi_debe <> 0 then asi_origen 
-- 															 else -asi_origen 
-- 													end 
-- 									 else 
-- 													case when asi_debe <> 0 then asi_debe
-- 															 else -asi_haber
-- 													end 
-- 							end				) * coti.cotizacion,
-- 
-- 					case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre end,
-- 					cue.mon_id,
-- 					sum(case when asi_debe <> 0 then asi_origen else -asi_origen end),
-- 					coti.cotizacion
-- 
-- 		from
-- 		
-- 					AsientoItem asi inner join Asiento ast on asi.as_id = ast.as_id
-- 													inner join Documento doc on ast.doc_id = doc.doc_id		
-- 													inner join Cuenta cue on asi.cue_id = cue.cue_id
-- 													inner join Moneda mon on cue.mon_id = mon.mon_id
-- 													left  join #t_cotizacion coti on cue.mon_id = coti.mon_id
-- 		where 
-- 						  as_fecha between @@Fini and @@Ffin
-- 					and (
-- 								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
-- 							)
-- 		and   (asi.cue_id = @cue_id or @cue_id=0)
-- 		and   ((exists(select rptarb_hojaid from rptArbolRamaHoja where rptarb_cliente = @clienteID and tbl_id = 17 and rptarb_hojaid = asi.cue_id)) or (@ram_id_cuenta = 0))
-- 
-- 		group by 
-- 							case when cue_codigorpt <> '' then cue_codigorpt else cue_nombre end, 
-- 							asi.as_id, ast.doct_id,
-- 						  coti.cotizacion, cue.mon_id


/*- ///////////////////////////////////////////////////////////////////////

VENTAS - PEDIDOS

/////////////////////////////////////////////////////////////////////// */

-- 	-- Saldo Inicial
-- 
-- 	insert into #t_dc_csc_tsr_0210 (tipo, pr_id, saldo)
-- 
-- 		select 
-- 					3,
-- 					pvi.pr_id,
-- 					sum(case when pv_total = 0 or pvi_cantidad = 0 
-- 									 then 0 
-- 									 else pvi_pendiente * (pvi_neto/pvi_cantidad) *pv_neto / pv_total 
-- 							end 
-- 							* 
-- 							case pv.doct_id when 22 then -1 else 1 end
-- 							)
-- 		from
-- 		
-- 					PedidoVentaItem pvi inner join PedidoVenta pv on pvi.pv_id = pv.pv_id
-- 															inner join Documento doc on pv.doc_id = doc.doc_id
-- 		
-- 		where 
-- 						  pv_fecha < @@Fini  
-- 					and pv.est_id not in (7,5)
-- 					and pvi_pendiente > 0
-- 					and (
-- 								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
-- 							)
-- 		
-- 		group by pvi.pr_id

	-- Entre fechas

	insert into #t_dc_csc_tsr_0210 (tipo, pr_id, doct_id, comp_id, saldo, mon_id, saldoorigen, cotizacion)

		select 
					4,
					pvi.pr_id,
					pv.doct_id,
					pvi.pv_id,
					sum(case when pv_total = 0 or pvi_cantidad = 0 
									 then 0 
									 else (pvi_pendiente * (pvi_neto/pvi_cantidad) * (pv_total/pv_neto)) * coti.cotizacion
							end 
							* 
							case pv.doct_id when 22 then -1 else 1 end
							),
					doc.mon_id,
					sum(case when pv_total = 0 or pvi_cantidad = 0 
									 then 0 
									 else (pvi_pendiente * (pvi_neto/pvi_cantidad) * (pv_total/pv_neto))
							end 
							* 
							case pv.doct_id when 22 then -1 else 1 end
							),
					coti.cotizacion

		from
		
					PedidoVentaItem pvi inner join PedidoVenta pv 		on pvi.pv_id  = pv.pv_id
															inner join Documento doc 			on pv.doc_id  = doc.doc_id
															left join #t_cotizacion coti 	on doc.mon_id = coti.mon_id
		
		where 
						  pv_fecha <= @@Ffin
					and pv.est_id not in (7,5)
					and pvi_pendiente > 0
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		group by 	pvi.pr_id, 
							pvi.pv_id, 
							pv.doct_id,
						 	coti.cotizacion,
							doc.mon_id

/*- ///////////////////////////////////////////////////////////////////////

VENTAS - FACTURAS

/////////////////////////////////////////////////////////////////////// */

	-- Saldo Inicial

-- 	insert into #t_dc_csc_tsr_0210 (tipo, pr_id, saldo)
-- 
-- 		select 
-- 					5,
-- 					fvi.pr_id,
-- 					sum(case when fv_total = 0 or fvi_cantidad = 0 or fv_totalcomercial = 0 or to_generadeuda = 0
-- 									 then 0 
-- 									 else fvi_pendiente * (fvi_neto/fvi_cantidad) *fv_neto / fv_total 
-- 							end 
-- 							* 
-- 							case fv.doct_id when 7 then -1 else 1 end
-- 							)
-- 		from
-- 		
-- 					FacturaVentaItem fvi inner join FacturaVenta fv on fvi.fv_id = fv.fv_id
-- 															 inner join Documento doc on fv.doc_id = doc.doc_id
-- 															 inner join TipoOperacion op on fvi.to_id = op.to_id
-- 		
-- 		where 
-- 						  fv_fecha < @@Fini  
-- 					and fv.est_id not in (7,5)
-- 					and fvi_pendiente > 0
-- 					and (
-- 								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
-- 							)
-- 		
-- 		group by fvi.pr_id

	-- Entre fechas

	insert into #t_dc_csc_tsr_0210 (tipo, pr_id, doct_id, comp_id, saldo)

		select 
					6,
					fvi.pr_id,
					fv.doct_id,
					fvi.fv_id,
					sum(case when fv_neto = 0 or fvi_cantidad = 0 or fv_totalcomercial = 0 or to_generadeuda = 0
									 then 0 
									 else fvi_importe * (fv_pendiente/fv_total)
							end 
							* 
							case fv.doct_id when 7 then -1 else 1 end
							)
		from
		
					FacturaVentaItem fvi inner join FacturaVenta fv on fvi.fv_id = fv.fv_id
															 inner join Documento doc on fv.doc_id = doc.doc_id
															 inner join TipoOperacion op on fvi.to_id = op.to_id		
		where 
						  fv_fecha <= @@Ffin
					and fv.est_id not in (7,5)
					and fvi_pendiente > 0
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		group by fvi.pr_id, fvi.fv_id, fv.doct_id

/*- ///////////////////////////////////////////////////////////////////////

COMPRAS - FACTURAS

/////////////////////////////////////////////////////////////////////// */

	-- Saldo Inicial

-- 	insert into #t_dc_csc_tsr_0210 (tipo, pr_id, saldo)
-- 
-- 		select 
-- 					7,
-- 					fci.pr_id,
-- 					sum(case when fc_total = 0 or fci_cantidad = 0 
-- 									 then 0 
-- 									 else fci_pendiente * (fci_neto/fci_cantidad) *fc_neto / fc_total 
-- 							end 
-- 							* 
-- 							case fc.doct_id when 8 then -1 else 1 end
-- 							)
-- 		from
-- 		
-- 					FacturaCompraItem fci inner join FacturaCompra fc on fci.fc_id = fc.fc_id
-- 															 inner join Documento doc on fc.doc_id = doc.doc_id
-- 		
-- 		where 
-- 						  fc_fecha < @@Fini  
-- 					and fc.est_id not in (7,5)
-- 					and fci_pendiente > 0
-- 					and (
-- 								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
-- 							)
-- 		
-- 		group by fci.pr_id

	-- Entre fechas

	insert into #t_dc_csc_tsr_0210 (tipo, pr_id, doct_id, comp_id, saldo)

		select 
					8,
					fci.pr_id,
					fc.doct_id,
					fci.fc_id,
					sum(case when fc_neto = 0 or fci_cantidad = 0 
									 then 0 
									 else fci_importe * (fc_pendiente/fc_total)
							end 
							* 
							case fc.doct_id when 8 then -1 else 1 end
							)
		from
		
					FacturaCompraItem fci inner join FacturaCompra fc on fci.fc_id = fc.fc_id
															 inner join Documento doc on fc.doc_id = doc.doc_id
		
		where 
						  fc_fecha <= @@Ffin
					and fc.est_id not in (7,5)
					and fci_pendiente > 0
					and (
								exists(select * from EmpresaUsuario where emp_id = doc.emp_id and us_id = @@us_id) or (@@us_id = 1)
							)
		
		group by fci.pr_id, fci.fc_id, fc.doct_id


/*- ///////////////////////////////////////////////////////////////////////

SELECT DE RETORNO

/////////////////////////////////////////////////////////////////////// */

	select 
			case 
				when t.tipo in (1,2) then 1
				when t.tipo in (3,4) then 3
				when t.tipo in (5,6) then 5
				else                 			7
			end																								as tipo,
			t.comp_id,
			t.doct_id,
			case
				when t.tipo in (1,2,3,4,5,6) then   t.saldo
				else                              - t.saldo
			end																								as saldo,

			case
				when t.tipo in (1,2,3,4,5,6) then   t.saldoorigen
				else                              - t.saldoorigen
			end																								as saldoorigen,

			mon_nombre,
			t.cotizacion,

			case 
				when t.tipo in (1,2) then 'Disponibilidades'
				when t.tipo in (3,4) then 'Pedidos de Venta Pendientes'
				when t.tipo in (5,6) then 'Facturas de Venta Pendientes'
				else                 			'Facturas de Compra Pendientes'
			end																								as tipo_descrip,

			isnull(isnull(isnull(as_nrodoc,fv_nrodoc),pv_nrodoc),fc_nrodoc)			
																												as nro_doc,
			isnull(isnull(isnull(as_fecha,fv_fecha),pv_fecha),fc_fecha)				
																												as fecha,

			case 
					when t.tipo in (1,3,5,7) then 'Saldo Inicial'
					when t.tipo = 2          then 'Asiento Contable'
					else													isnull(cli_nombre,prov_nombre)										
			end 																							as tercero,

			isnull(cuenta, 
						 case when fv.fv_id is null then pr_nombrecompra else pr_nombreventa end)
																												as Concepto

	from #t_dc_csc_tsr_0210 t left join asiento ast on t.doct_id = ast.doct_id and t.comp_id = ast.as_id
														left join facturaventa fv on t.doct_id = fv.doct_id and t.comp_id = fv.fv_id
														left join pedidoventa pv on t.doct_id = pv.doct_id and t.comp_id = pv.pv_id
														left join facturacompra fc on t.doct_id = fc.doct_id and t.comp_id = fc.fc_id
														left join cliente cli on fv.cli_id = cli.cli_id or pv.cli_id = cli.cli_id
														left join proveedor prov on fc.prov_id = prov.prov_id
														left join producto pr on t.pr_id = pr.pr_id
														left join moneda mon on t.mon_id = mon.mon_id

	order by t.tipo, fecha, concepto

end

GO
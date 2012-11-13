if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocOrdenPagoGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocOrdenPagoGetItems]

go

/*

exec sp_DocOrdenPagoGetItems 12,1
exec sp_DocOrdenPagoGetItems 12,2
exec sp_DocOrdenPagoGetItems 12,3
exec sp_DocOrdenPagoGetItems 12,4
exec sp_DocOrdenPagoGetItems 12,5

sp_columns cheque

*/
create procedure sp_DocOrdenPagoGetItems (
	@@opg_id 			  int,
  @@tipo          tinyint
)
as

begin

declare @OpgiTCheques      tinyint set @OpgiTCheques  = 1
declare @OpgiTEfectivo     tinyint set @OpgiTEfectivo = 2
declare @OpgiTOtros        tinyint set @OpgiTOtros    = 4
declare @OpgiTCtaCte       tinyint set @OpgiTCtaCte   = 5
declare @OpgiTChequesT     tinyint set @OpgiTChequesT = 6

	if @@tipo = @OpgiTCheques begin

		select 	OrdenPagoItem.*, 
						chq_codigo,
            cheq_numero,
	          ccos_nombre,
            cue_nombre,
            bco_nombre,
						cle_nombre,
            mon_nombre,
            mon.mon_id,
            cheq_numerodoc,
            bco.bco_id,
            cle.cle_id,
            cheq_fechavto,
            cheq_fechacobro
	
		from 	OrdenPagoItem
					inner join cheque     as cheq     on OrdenPagoItem.cheq_id = cheq.cheq_id

					-- Este Inner join filtra a los cheques de tercero ya que estos no tienen
          -- chequera
					--
					inner join chequera   as chq      on OrdenPagoItem.chq_id  = chq.chq_id   

	        left join centrocosto as ccos 		on OrdenPagoItem.ccos_id = ccos.ccos_id
          left join banco       as bco      on cheq.bco_id  = bco.bco_id
          left join clearing    as cle      on cheq.cle_id  = cle.cle_id
          left join cuenta      as cue      on OrdenPagoItem.cue_id  = cue.cue_id
          left join moneda      as mon      on cheq.mon_id  = mon.mon_id
		where 
				OrdenPagoItem.opg_id 		= @@opg_id
    and opgi_tipo							  = @OpgiTCheques
		order by opgi_orden

	end else begin

		if @@tipo = @OpgiTEfectivo begin
	
			select 	OrdenPagoItem.*, 
		          ccos_nombre,
	            cue_nombre,
	            mon_nombre,
              mon.mon_id
		
			from 	OrdenPagoItem
	          inner join cuenta      as cue      on OrdenPagoItem.cue_id  = cue.cue_id
	          inner join moneda      as mon      on cue.mon_id  = mon.mon_id
		        left join centrocosto  as ccos 		 on OrdenPagoItem.ccos_id = ccos.ccos_id
			where 
					OrdenPagoItem.opg_id 		= @@opg_id
	    and opgi_tipo							  = @OpgiTEfectivo
			order by opgi_orden
	
		end else begin

			if @@tipo = @OpgiTOtros begin
		
				select 	OrdenPagoItem.*, 
			          ccos_nombre,
                cue_nombre,
                ret_nombre,
								fc_nrodoc
			
				from 	OrdenPagoItem
			        left join centrocosto 	as ccos 		on OrdenPagoItem.ccos_id = ccos.ccos_id
		          left join cuenta      	as cue      on OrdenPagoItem.cue_id  = cue.cue_id
              left join retencion   	as ret      on OrdenPagoItem.ret_id  = ret.ret_id
							left join facturacompra as fc       on OrdenPagoItem.fc_id_ret  = fc.fc_id
				where 
						OrdenPagoItem.opg_id 		= @@opg_id
		    and opgi_tipo							  = @OpgiTOtros
				order by opgi_orden
		
			end else begin
		
				if @@tipo = @OpgiTCtaCte begin
			
					select 	OrdenPagoItem.*, 
				          ccos_nombre,
									cue_nombre
				
					from 	OrdenPagoItem
				        left join centrocosto as ccos 		on OrdenPagoItem.ccos_id = ccos.ccos_id
		            left join cuenta      as cue      on OrdenPagoItem.cue_id  = cue.cue_id
					where 
							OrdenPagoItem.opg_id 		= @@opg_id
			    and opgi_tipo							  = @OpgiTCtaCte
					order by opgi_orden

				end	else begin

					if @@tipo = @OpgiTChequesT begin
				
						select 	OrdenPagoItem.*, 
				            cheq_numero,
					          ccos_nombre,
				            cue_nombre,
										cheq.bco_id,
										cheq.cle_id,
				            bco_nombre,
										cle_nombre,
										cli_nombre,
				            mon_nombre,
				            mon.mon_id,
				            cheq_numerodoc,
				            cheq_fechavto,
				            cheq_fechacobro
					
						from 	OrdenPagoItem
									inner join cheque     as cheq     on OrdenPagoItem.cheq_id = cheq.cheq_id
				
									left join cliente     as cli      on cheq.cli_id  = cli.cli_id   
									
					        left join centrocosto as ccos 		on OrdenPagoItem.ccos_id = ccos.ccos_id
				          left join banco       as bco      on cheq.bco_id  = bco.bco_id
				          left join clearing    as cle      on cheq.cle_id  = cle.cle_id
				          left join cuenta      as cue      on OrdenPagoItem.cue_id  = cue.cue_id
				          left join moneda      as mon      on cheq.mon_id  = mon.mon_id
						where 
								OrdenPagoItem.opg_id 		= @@opg_id
				    and opgi_tipo							  = @OpgiTChequesT
						order by opgi_orden
					end 
				end
			end
		end
	end
end


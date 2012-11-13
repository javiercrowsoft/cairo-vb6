if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaVentaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaVentaGet]

go

/*

sp_DocFacturaVentaGet 13,7

*/

create procedure sp_DocFacturaVentaGet (
	@@emp_id   int,
	@@fv_id    int,
  @@us_id    int
)
as

begin

declare @bEditable 		tinyint
declare @editMsg   		varchar(255)
declare @doc_id    		int
declare @doct_id   		int
declare @ta_Mascara 	varchar(100)
declare @ta_Propuesto tinyint

declare @DeplNombre   	varchar(255)
declare @DeplId   int
declare	@DepfId   int

declare @bIvari		tinyint
declare @bIvarni  tinyint
declare @cli_id   int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @cli_id = cli_id, @doc_id = doc_id, @doct_id = doct_id from FacturaVenta where fv_id = @@fv_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out, @cli_id, 0
	exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
  exec sp_DocFacturaVentaEditableGet @@emp_id, @@fv_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             DEPOSITO                                                                               //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @doct_id = 1 /*Factura de Venta*/or @doct_id = 9 /*Nota de Debito Venta*/begin

		select
	
				@DeplNombre   	= dOrigen.depl_nombre,
	      @DeplId   			= depl_id_origen,
				@DepfId       	= depf_id
	
		from 
				FacturaVenta  inner join Stock          						 on FacturaVenta.st_id   = Stock.st_id
										  left  join DepositoLogico as dOrigen   on	Stock.depl_id_origen  = dOrigen.depl_id
		where fv_id = @@fv_id
	
		set @DeplNombre = IsNull(@DeplNombre,'')
	  set @DeplId   	= IsNull(@DeplId,0)
	
		if @DeplId = 0 begin
	
			select
		
					@DeplNombre   = dOrigen.depl_nombre,
		      @DeplId   		= depl_id_origen,
					@DepfId       = depf_id
		
			from 
					FacturaVenta  inner join RemitoVenta                 on FacturaVenta.rv_id   = RemitoVenta.rv_id
											  inner join Stock          						 on RemitoVenta.st_id    = Stock.st_id
											  left  join DepositoLogico as dOrigen   on	Stock.depl_id_origen  = dOrigen.depl_id
			where fv_id = @@fv_id
		end

	end else begin if @doct_id = 7 /*Nota de Credito Venta*/

		select
	
				@DeplNombre   	= dDestino.depl_nombre,
	      @DeplId   			= depl_id_destino,
				@DepfId       	= depf_id
	
		from 
				FacturaVenta  inner join Stock          						 on FacturaVenta.st_id    = Stock.st_id
										  left  join DepositoLogico as dDestino  on	Stock.depl_id_destino  = dDestino.depl_id
		where fv_id = @@fv_id
	
		set @DeplNombre = IsNull(@DeplNombre,'')
	  set @DeplId   	= IsNull(@DeplId,0)
	
		if @DeplId = 0 begin
	
			select
		
					@DeplNombre 	= dDestino.depl_nombre,
		      @DeplId   		= depl_id_destino,
					@DepfId       = depf_id		

			from 
					FacturaVenta  inner join RemitoVenta              	 on FacturaVenta.rv_id   = RemitoVenta.rv_id
											 	inner join Stock          						 on RemitoVenta.st_id    = Stock.st_id
											 	left  join DepositoLogico as dDestino  on	Stock.depl_id_destino = dDestino.depl_id
			where fv_id = @@fv_id
		end
	end

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	select 
			FacturaVenta.*,
			documento.doc_fv_sinpercepcion,
	    cli_nombre,
	    lp_nombre,
	    ld_nombre,
	    cpg_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
      ven_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      pOrigen.pro_nombre  as ProOrigen,
      pDestino.pro_nombre as ProDestino,
      trans_nombre,
			clis_nombre,

      @DeplId   					as depl_id,
      @DeplNombre   			as depl_nombre,
			@DepfId             as depf_id,
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			FacturaVenta inner join documento      on FacturaVenta.doc_id  = documento.doc_id
                   inner join condicionpago  on FacturaVenta.cpg_id  = condicionpago.cpg_id
									 inner join estado         on FacturaVenta.est_id  = estado.est_id
									 inner join sucursal       on FacturaVenta.suc_id  = sucursal.suc_id
                   inner join Cliente        on FacturaVenta.cli_id  = Cliente.cli_id
                   left join centrocosto     on FacturaVenta.ccos_id = centrocosto.ccos_id
                   left join listaprecio     on FacturaVenta.lp_id   = listaprecio.lp_id
									 left join listadescuento  on FacturaVenta.ld_id   = listadescuento.ld_id
                   left join vendedor        on FacturaVenta.ven_id  = vendedor.ven_id
                   left join legajo          on FacturaVenta.lgj_id  = legajo.lgj_id

									 left join Provincia as pOrigen  on	FacturaVenta.pro_id_origen  = pOrigen.pro_id
									 left join Provincia as pDestino on	FacturaVenta.pro_id_destino = pDestino.pro_id

									 left join Transporte      on FacturaVenta.trans_id = Transporte.trans_id

									 left join ClienteSucursal on FacturaVenta.clis_id = ClienteSucursal.clis_id

  where fv_id = @@fv_id

end
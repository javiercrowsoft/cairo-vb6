if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocFacturaCompraGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocFacturaCompraGet]

go

/*
select us_id from usuario
select fc_id from FacturaCompra 
sp_DocFacturaCompraGet 13,7
sp_DocFacturaCompraGet 0,7

*/

create procedure sp_DocFacturaCompraGet (
	@@emp_id   int,
	@@fc_id    int,
  @@us_id    int
)
as

begin

declare @bEditable tinyint
declare @editMsg   varchar(255)
declare @doc_id    		int
declare @doct_id   		int
declare @ta_Mascara 	varchar(100)
declare @ta_Propuesto tinyint

declare @DeplNombre   	varchar(255)
declare @DeplId   int

declare @bIvari		 tinyint
declare @bIvarni   tinyint
declare @prov_id   int


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @prov_id = prov_id, @doc_id = doc_id, @doct_id = doct_id from FacturaCompra where fc_id = @@fc_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out, 0, @prov_id
	exec sp_ProveedorGetIva @prov_id, @bIvari out, @bIvarni out, 0
  exec sp_DocFacturaCompraEditableGet @@emp_id, @@fc_id, @@us_id, @bEditable out, @editMsg out


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             DEPOSITO                                                                               //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

	if @doct_id = 2 /*Factura de Compra*/or @doct_id = 10 /*Nota de Debito Compra*/begin

		select
	
				@DeplNombre   	= dDestino.depl_nombre,
	      @DeplId   			= depl_id_destino
	
		from 
				FacturaCompra inner join Stock          						 on FacturaCompra.st_id    = Stock.st_id
										  left  join DepositoLogico as dDestino  on	Stock.depl_id_destino  = dDestino.depl_id
		where fc_id = @@fc_id
	
		set @DeplNombre = IsNull(@DeplNombre,'')
	  set @DeplId   	= IsNull(@DeplId,0)
	
		if @DeplId = 0 begin
	
			select
		
					@DeplNombre = dDestino.depl_nombre,
		      @DeplId   	= depl_id_destino
		
			from 
					FacturaCompra inner join RemitoCompra              	 on FacturaCompra.rc_id   = RemitoCompra.rc_id
											 	inner join Stock          						 on RemitoCompra.st_id    = Stock.st_id
											 	left  join DepositoLogico as dDestino  on	Stock.depl_id_destino = dDestino.depl_id
			where fc_id = @@fc_id
		end

	end else begin if @doct_id = 8 /*Nota de Credito Compra*/

		select
	
				@DeplNombre   	= dOrigen.depl_nombre,
	      @DeplId   			= depl_id_origen
	
		from 
				FacturaCompra inner join Stock          						 on FacturaCompra.st_id   = Stock.st_id
										  left  join DepositoLogico as dOrigen   on	Stock.depl_id_origen  = dOrigen.depl_id
		where fc_id = @@fc_id
	
		set @DeplNombre = IsNull(@DeplNombre,'')
	  set @DeplId   	= IsNull(@DeplId,0)
	
		if @DeplId = 0 begin
	
			select
		
					@DeplNombre   = dOrigen.depl_nombre,
		      @DeplId   		= depl_id_origen
		
			from 
					FacturaCompra inner join RemitoCompra                on FacturaCompra.rc_id   = RemitoCompra.rc_id
											  inner join Stock          						 on RemitoCompra.st_id    = Stock.st_id
											  left  join DepositoLogico as dOrigen   on	Stock.depl_id_origen  = dOrigen.depl_id
			where fc_id = @@fc_id
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
			FacturaCompra.*,
	    prov_nombre,
	    lp_nombre,
	    ld_nombre,
	    cpg_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      pOrigen.pro_nombre  as ProOrigen,
      pDestino.pro_nombre as ProDestino,
      @DeplId   					as depl_id,
      @DeplNombre   			as depl_nombre,
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable					as editable,
      @editMsg						as editMsg,
			@ta_Mascara					as TaMascara,
			@ta_Propuesto				as TaPropuesto
	
	from 
			FacturaCompra inner join documento      on FacturaCompra.doc_id  = documento.doc_id
                    inner join condicionpago  on FacturaCompra.cpg_id  = condicionpago.cpg_id
									  inner join estado         on FacturaCompra.est_id  = estado.est_id
									  inner join sucursal       on FacturaCompra.suc_id  = sucursal.suc_id
                    inner join Proveedor      on FacturaCompra.prov_id = Proveedor.prov_id
                    left join centrocosto     on FacturaCompra.ccos_id = centrocosto.ccos_id
                    left join listaprecio     on FacturaCompra.lp_id   = listaprecio.lp_id
									  left join listadescuento  on FacturaCompra.ld_id   = listadescuento.ld_id
                    left join legajo          on FacturaCompra.lgj_id  = legajo.lgj_id

									  left join Provincia as pOrigen  on	FacturaCompra.pro_id_origen  = pOrigen.pro_id
									  left join Provincia as pDestino on	FacturaCompra.pro_id_destino = pDestino.pro_id

  where fc_id = @@fc_id

end
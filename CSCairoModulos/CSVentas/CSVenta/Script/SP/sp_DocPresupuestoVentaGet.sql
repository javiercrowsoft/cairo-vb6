if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoVentaGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoVentaGet]

go

/*

sp_DocPresupuestoVentaGet 8,7

*/

create procedure sp_DocPresupuestoVentaGet (
	@@emp_id   int,
	@@prv_id   int,
  @@us_id    int
)
as

begin

declare @bEditable 		tinyint
declare @editMsg   		varchar(255)
declare @doc_id    		int
declare @ta_Mascara 	varchar(100)
declare @ta_Propuesto tinyint

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
  select @cli_id = cli_id, @doc_id = doc_id from PresupuestoVenta where prv_id = @@prv_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
	exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
  exec sp_DocPresupuestoVentaEditableGet @@emp_id, @@prv_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			Presupuestoventa.*,
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
			prov_nombre,
			cont_nombre,

      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			Presupuestoventa inner join documento on Presupuestoventa.doc_id  = documento.doc_id
                  inner join condicionpago 	on Presupuestoventa.cpg_id  = condicionpago.cpg_id
									inner join estado        	on Presupuestoventa.est_id  = estado.est_id
									inner join sucursal      	on Presupuestoventa.suc_id  = sucursal.suc_id
                  inner join cliente       	on Presupuestoventa.cli_id  = cliente.cli_id
                  left join centrocosto    	on Presupuestoventa.ccos_id = centrocosto.ccos_id
                  left join listaprecio    	on Presupuestoventa.lp_id   = listaprecio.lp_id
									left join listadescuento 	on Presupuestoventa.ld_id   = listadescuento.ld_id

									left join vendedor        on Presupuestoventa.ven_id  = vendedor.ven_id
									left join legajo          on Presupuestoventa.lgj_id  = legajo.lgj_id
									
									left join Provincia as pOrigen  on	Presupuestoventa.pro_id_origen  = pOrigen.pro_id
									left join Provincia as pDestino on	Presupuestoventa.pro_id_destino = pDestino.pro_id
									
									left join Transporte      on Presupuestoventa.trans_id = Transporte.trans_id

									left join ClienteSucursal on Presupuestoventa.clis_id = ClienteSucursal.clis_id

									left join Proveedor prov  on Presupuestoventa.prov_id = prov.prov_id
									left join Contacto cont  on Presupuestoventa.cont_id = cont.cont_id

  where prv_id = @@prv_id

end
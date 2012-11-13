if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPresupuestoEnvioGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPresupuestoEnvioGet]

go

/*

PresupuestoEnvio                   reemplazar por el nombre del documento Ej. PedidoVenta
@@pree_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
PresupuestoEnvio                 reemplazar por el nombre de la tabla ej PedidoVenta
pree_id                     reemplazar por el campo ID ej. pv_id
del presupuesto                  reemplazar por el texto de error ej. del pedido de venta
Cliente        reemplazar por Cliente o Proveedor segun el circuito
cli_        reemplazar por cli_ o prov_ segun el circuito

exec sp_DocPresupuestoEnvioEditableGet 57, 7, 0, '',1
sp_DocPresupuestoEnvioGet 57,7
select max(pv_numero) from PresupuestoEnvio
select pv_id from PresupuestoEnvio where XX_numero = 57
*/

create procedure sp_DocPresupuestoEnvioGet (
	@@emp_id   int,
	@@pree_id  int,
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
  select @cli_id = cli_id, @doc_id = doc_id from PresupuestoEnvio where pree_id = @@pree_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out, @cli_id, 0
	exec sp_clienteGetIva @cli_id, @bIvari out, @bIvarni out, 0
  exec sp_DocPresupuestoEnvioEditableGet @@emp_id, @@pree_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			PresupuestoEnvio.*,
	    cli_nombre,
	    cpg_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
      ven_nombre,
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			PresupuestoEnvio inner join documento      on PresupuestoEnvio.doc_id  = documento.doc_id
                   inner join condicionpago      on PresupuestoEnvio.cpg_id  = condicionpago.cpg_id
									 inner join estado             on PresupuestoEnvio.est_id  = estado.est_id
									 inner join sucursal           on PresupuestoEnvio.suc_id  = sucursal.suc_id
                   inner join cliente            on PresupuestoEnvio.cli_id  = cliente.cli_id
                   left join centrocosto         on PresupuestoEnvio.ccos_id = centrocosto.ccos_id
                   left join vendedor            on PresupuestoEnvio.ven_id  = vendedor.ven_id

  where pree_id = @@pree_id

end
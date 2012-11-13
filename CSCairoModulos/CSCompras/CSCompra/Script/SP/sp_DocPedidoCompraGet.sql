if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPedidoCompraGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPedidoCompraGet]

go

/*

PedidoCompra                   reemplazar por el nombre del documento Ej. PedidoVenta
@@pc_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
PedidoCompra                 reemplazar por el nombre de la tabla ej PedidoVenta
pc_id                     reemplazar por el campo ID ej. pv_id
del pedido de compras                  reemplazar por el texto de error ej. del pedido de venta

exec sp_DocPedidoCompraEditableGet 57, 7, 0, '',1
sp_DocPedidoCompraGet 57,7
select max(pv_numero) from PedidoCompra
select pv_id from PedidoCompra where XX_numero = 57
*/

create procedure sp_DocPedidoCompraGet (
	@@emp_id   int,
	@@pc_id    int,
  @@us_id    int
)
as

begin

declare @bEditable 		tinyint
declare @editMsg   		varchar(255)
declare @doc_id    		int
declare @ta_Mascara 	varchar(100)
declare @ta_Propuesto tinyint

declare @bIvari				tinyint
declare @bIvarni  		tinyint
declare @us_id   		int

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             TALONARIO Y ESTADO DE EDICION                                                          //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
  select @us_id = us_id, @doc_id = doc_id from PedidoCompra where pc_id = @@pc_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocPedidoCompraEditableGet @@emp_id, @@pc_id, @@us_id, @bEditable out, @editMsg out

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                             SELECT                                                                                 //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
	select 
			PedidoCompra.*,
	    us_nombre,
	    lp_nombre,
	    est_nombre,
	    ccos_nombre,
      suc_nombre,
      doc_nombre,
			case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      @bIvari             as bIvaRi,
      @bIvarni            as bIvaRni,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			PedidoCompra inner join documento      on PedidoCompra.doc_id  = documento.doc_id
									 inner join estado         on PedidoCompra.est_id  = estado.est_id
									 inner join sucursal       on PedidoCompra.suc_id  = sucursal.suc_id
                   inner join usuario        on PedidoCompra.us_id   = usuario.us_id
                   left join centrocosto     on PedidoCompra.ccos_id = centrocosto.ccos_id
                   left join listaprecio     on PedidoCompra.lp_id   = listaprecio.lp_id
									 left join legajo          on PedidoCompra.lgj_id  = legajo.lgj_id

  where pc_id = @@pc_id

end
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocImportacionTempGetGarantias]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocImportacionTempGetGarantias]

go

/*

ImportacionTemp                   reemplazar por el nombre del documento Ej. PedidoVenta
@@impt_id                     reemplazar por el id del documento ej @@pv_id  (incluir 2 arrobas)
ImportacionTemp                 reemplazar por el nombre de la tabla ej PedidoVenta
impt_id                     reemplazar por el campo ID ej. pv_id
pr_nombreCompra        reemplazar por el nombre del campo producto Ej. pr_nombreventa o pr_nombrecompra
select impt_id from ImportacionTemp

sp_DocImportacionTempGetGarantias 9

*/
create procedure sp_DocImportacionTempGetGarantias (
	@@impt_id int
)
as

begin

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  IMPORTACION TEMPORAL ITEMS
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////

	select 	ImportacionTempGarantia.*, 
					gar_nropoliza

	from 	ImportacionTempGarantia
				inner join Garantia 							on ImportacionTempGarantia.gar_id = Garantia.gar_id

	where 
			impt_id = @@impt_id

	order by imptg_orden

	--///////////////////////////////////////////////////////////////////////////////////////////////////
  --
	--  NUMEROS DE SERIE
	--
	--///////////////////////////////////////////////////////////////////////////////////////////////////

	select 
									prns.prns_id,
									prns_codigo,
									prns_descrip,
									prns_fechavto,
					  			impti_id

	from ProductoNumeroSerie prns inner join StockItem sti 						on prns.prns_id   = sti.prns_id
																inner join ImportacionTempItem rci 		on sti.sti_grupo  = rci.impti_id
																inner join ImportacionTemp rc          on rci.impt_id      = rc.impt_id
	where rci.impt_id = @@impt_id and sti.st_id = rc.st_id

	group by
					prns.prns_id,
					prns_codigo,
					prns_descrip,
					prns_fechavto,
	  			impti_id
	order by
					impti_id

end
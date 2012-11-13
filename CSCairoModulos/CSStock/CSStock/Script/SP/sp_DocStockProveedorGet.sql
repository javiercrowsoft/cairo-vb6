if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocStockProveedorGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocStockProveedorGet]

go

/*

sp_DocStockProveedorGet 8,7

*/

create procedure sp_DocStockProveedorGet (
	@@emp_id   			int,
	@@stprov_id     int,
  @@us_id    			int
)
as

begin

declare @bEditable 		tinyint
declare @editMsg   		varchar(255)
declare @doc_id    		int
declare @ta_id        int
declare @ta_Mascara 	varchar(100)
declare @ta_Propuesto tinyint


  select @doc_id = doc_id from StockProveedor where stprov_id = @@stprov_id

	exec sp_talonarioGetPropuesto @doc_id, @ta_Mascara out, @ta_Propuesto out
  exec sp_DocStockProveedorEditableGet @@emp_id, @@stprov_id, @@us_id, @bEditable out, @editMsg out

	select 
			stprov.*,
			prov_nombre,
			origen.depl_nombre 	as [Origen],
			destino.depl_nombre as [Destino],
			origen.depf_id,
	    case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      suc_nombre,
      doc_nombre,
      @bEditable					as editable,
      @editMsg						as editMsg,
      @ta_Propuesto 			as TaPropuesto,
			@ta_Mascara					as TaMascara
	
	from 
			StockProveedor stprov		
								  inner join proveedor prov           on stprov.prov_id = prov.prov_id
									inner join documento doc 						on stprov.doc_id  = doc.doc_id
									inner join sucursal suc  						on stprov.suc_id  = suc.suc_id
									inner join DepositoLogico origen  	on stprov.depl_id_origen  = origen.depl_id
									inner join DepositoLogico destino		on stprov.depl_id_destino = destino.depl_id
                  left  join legajo lgj 		 					on stprov.lgj_id  = lgj.lgj_id

  where stprov_id = @@stprov_id

end
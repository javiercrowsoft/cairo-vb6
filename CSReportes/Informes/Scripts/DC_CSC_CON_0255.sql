/*---------------------------------------------------------------------
Nombre: Proceso para regenerar asientos de facturas de compra
---------------------------------------------------------------------*/

/*


[DC_CSC_CON_0255] 1


*/

if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_CON_0255]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_CON_0255]


go
create procedure DC_CSC_CON_0255 (

  @@us_id    		int


)as 
begin

  set nocount on

	select pr_id,
				 pr_nombrecompra 			as [Nombre Compra],
				 pr_nombreventa       as [Nombre Venta],
				 pr_codigo            as Codigo,
				 cuegv.cueg_nombre    as [Grupo de Cuenta Ventas],
				 cuev.cue_nombre			as [Cuenta de Ventas],
				 cuegc.cueg_nombre    as [Grupo de Cuenta Compras],
				 cuec.cue_nombre			as [Cuenta de Compras],
				 cli_nombre           as Cliente,
				 cuecli.cue_nombre    as [Cuenta Cliente],
				 prov_nombre          as Proveedor,
         cueprov.cue_nombre   as [Cuenta Proveedor]

	from Producto pr left join CuentaGrupo cuegv on pr.cueg_id_venta = cuegv.cueg_id
									 left join Cuenta cuev       on cuegv.cue_id = cuev.cue_id
									 left join CuentaGrupo cuegc on pr.cueg_id_compra = cuegc.cueg_id
									 left join Cuenta cuec       on cuegc.cue_id = cuec.cue_id

									 left join ClienteCuentaGrupo cuegcli on cuegv.cueg_id = cuegcli.cueg_id
									 left join Cuenta cuecli       				on cuegcli.cue_id = cuecli.cue_id
									 left join Cliente cli                on cuegcli.cli_id = cli.cli_id

									 left join ProveedorCuentaGrupo cuegprov on cuegc.cueg_id = cuegprov.cueg_id
									 left join Cuenta cueprov       				 on cuegprov.cue_id = cueprov.cue_id
									 left join Proveedor prov                on cuegprov.prov_id = prov.prov_id
end
go
 
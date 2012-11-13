/*

select * from OrdenCompra
frOrdenCompra 2

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[frOrdenCompra]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[frOrdenCompra]

go
create procedure frOrdenCompra (

	@@oc_id			int

)as 

begin

	select 
				OrdenCompra.*, 
				OrdenCompraItem.*, 
				doc_nombre, 
				ccos_nombre, 
				prov_nombre as proveedor, 
				cpg_nombre, 
				prov_cuit,

			case prov_catfiscal
				when 1 then 'Inscripto'
				when 2 then 'Exento'
				when 3 then 'No inscripto'
				when 4 then 'Consumidor Final'
				when 5 then 'Extranjero'
				when 6 then 'Mono Tributo'
				when 7 then 'Extranjero Iva'
				when 8 then 'No responsable'
				when 9 then 'No Responsable exento'
				when 10 then 'No categorizado'
				when 11 then 'Inscripto M'
        else 'Sin categorizar'
			end as cat_fisctal,

			prov_calle + ' ' +
			prov_callenumero + ' ' +
			prov_piso + ' ' +
			prov_depto + ' (' +
			prov_codpostal + ')' as direccion,
      prov_localidad,
      case when lgj_titulo <> '' then lgj_titulo else lgj_codigo end as lgj_codigo,
      '(' + pr_codigoexterno + ') ' + pr_nombreCompra as producto
      

  from OrdenCompra inner join OrdenCompraItem 			on OrdenCompra.oc_id 					= OrdenCompraItem.oc_id
		               inner join Documento     				on OrdenCompra.doc_id        	= Documento.doc_id
		               inner join Proveedor      				on OrdenCompra.prov_id        = Proveedor.prov_id
		               inner join CondicionPago 				on OrdenCompra.cpg_id        	= CondicionPago.cpg_id
		               inner join Producto      				on OrdenCompraItem.pr_id     	= Producto.pr_id
		               left join  Legajo        				on OrdenCompra.lgj_id        	= Legajo.lgj_id
									 left join  CentroCosto 					on OrdenCompraItem.ccos_id    = CentroCosto.ccos_id

	where OrdenCompra.oc_id = @@oc_id

  order by oci_orden

end
go
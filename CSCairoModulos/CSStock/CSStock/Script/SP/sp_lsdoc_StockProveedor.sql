
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_StockProveedor]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_StockProveedor]

go
create procedure sp_lsdoc_StockProveedor (
@@stProv_id int
)as 
begin
select 
			stprov_id,
			''									  as [TypeTask],
			stprov_numero         as [Número],
			stprov_nrodoc					as [Comprobante],
			prov_nombre           as [Proveedor],
      doc_nombre					  as [Documento],
			stprov_fecha					as [Fecha],

      suc_nombre					  as [Sucursal],
			emp_nombre            as [Empresa],

			StockProveedor.Creado,
			StockProveedor.Modificado,
			us_nombre             as [Modifico],
			stprov_descrip				as [Observaciones]
from 
			StockProveedor inner join documento     on StockProveedor.doc_id   = documento.doc_id
										 inner join empresa       on documento.emp_id        = empresa.emp_id
										 inner join sucursal      on StockProveedor.suc_id   = sucursal.suc_id
	                   inner join Proveedor     on StockProveedor.prov_id  = Proveedor.prov_id
	                   inner join usuario       on StockProveedor.modifico = usuario.us_id
where 
				  
					@@stProv_id = stProv_id

end


if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_lsdoc_StockCliente]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_lsdoc_StockCliente]

go
create procedure sp_lsdoc_StockCliente (
@@stCli_id int
)as 
begin
select 
			stCli_id,
			''									  as [TypeTask],
			stCli_numero          as [Número],
			stCli_nrodoc					as [Comprobante],
			Cli_nombre            as [Cliente],
      doc_nombre					  as [Documento],
			stCli_fecha					  as [Fecha],

      suc_nombre					  as [Sucursal],
			emp_nombre            as [Empresa],

			StockCliente.Creado,
			StockCliente.Modificado,
			us_nombre             as [Modifico],
			stCli_descrip				  as [Observaciones]
from 
			StockCliente 	 inner join documento     on StockCliente.doc_id   = documento.doc_id
										 inner join empresa       on documento.emp_id      = empresa.emp_id
										 inner join sucursal      on StockCliente.suc_id   = sucursal.suc_id
	                   inner join Cliente       on StockCliente.Cli_id   = Cliente.Cli_id
	                   inner join usuario       on StockCliente.modifico = usuario.us_id
where 
				  
					@@stCli_id = stCli_id

end

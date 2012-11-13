if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_infoProveedorSaldo2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_infoProveedorSaldo2]

/*

sp_infoProveedorSaldo2 '',114,1

*/

go
create procedure sp_infoProveedorSaldo2 (
	@@us_id        int,
	@@emp_id       int,
	@@prov_id      int,
	@@info_aux     varchar(255) = ''
)
as

begin

	set nocount on

	select 

			  prov_deudaorden
			+ prov_deudaremito
			+ prov_deudactacte 			
			+ prov_deudadoc				as saldo,    

			prov_deudaorden,
			prov_deudaremito,
			prov_deudactacte,    
			prov_deudadoc,
			prov_deudatotal,
			prov_creditoctacte,
			prov_creditototal
	
	from Proveedor 

	where prov_id = @@prov_id

end
go
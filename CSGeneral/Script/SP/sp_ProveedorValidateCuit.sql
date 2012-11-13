/*

sp_ProveedorValidateCuit '30-20545896-0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProveedorValidateCuit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProveedorValidateCuit]

-- sp_ProveedorValidateCuit '30-52194421-4'

go
create procedure sp_ProveedorValidateCuit (
	@@Cuit			varchar(20)
)as 

begin

	if substring(@@cuit,1,2) = '55' or substring(@@cuit,1,2) = '50'
	begin

	  select prov_razonsocial, prov_id from proveedor where 1=2
	end else begin

	  select prov_razonsocial, prov_id from proveedor where prov_cuit=@@Cuit

	end

end
go


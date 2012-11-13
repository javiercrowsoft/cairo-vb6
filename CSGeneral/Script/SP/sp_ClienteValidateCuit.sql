/*

sp_ClienteValidateCuit '30-20545896-0'

*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ClienteValidateCuit]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ClienteValidateCuit]

-- sp_ClienteValidateCuit '30-59985019-4'

go
create procedure sp_ClienteValidateCuit (
	@@Cuit			varchar(20)
)
as 
begin

	if substring(@@cuit,1,2) = '55'
  or substring(@@cuit,1,2) = '50'
	or @@cuit = '00-00000000-0'
	or @@cuit = 'cuit'

	begin

	  select cli_razonsocial, cli_id from cliente where 1=2

	end else begin

	  select cli_razonsocial, cli_id from cliente where cli_cuit=@@Cuit

	end
end
go


if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_getClienteByNick]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_getClienteByNick]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_srv_cvxi_getClienteByNick  1, 'FMARQUEZ74'

create procedure sp_srv_cvxi_getClienteByNick (
	@@cmi_id		int,
	@@nick		 	varchar(255)
)
as

set nocount on

begin

	if @@cmi_id = 1 set @@nick = '(ml)#' + @@nick

	select  cli_nombre 			as nombre,
				  cli_tel      		as telefono,
					cli_email       as email,
					cli_calle + ' ' +
					cli_callenumero + ' ' +
					cli_piso + ' ' +
					cli_depto + ' (' +
					cli_codpostal + ') ' +
					cli_localidad		as direccion
					
	from Cliente

	where cli_codigocomunidad = @@nick


end

go
set quoted_identifier off 
go
set ansi_nulls on 
go




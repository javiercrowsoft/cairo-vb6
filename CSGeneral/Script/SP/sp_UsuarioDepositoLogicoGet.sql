if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_UsuarioDepositoLogicoGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_UsuarioDepositoLogicoGet]

/*

 select * from cliente where cli_codigo like '300%'
 select * from documento

 sp_UsuarioDepositoLogicoGet 35639

*/

go
create procedure sp_UsuarioDepositoLogicoGet (
	@@depl_id 		int
)
as

begin

	set nocount on

	select usdepl.*,
				 us_nombre

	from UsuarioDepositoLogico usdepl inner join usuario us on usdepl.us_id = us.us_id

	where depl_id = @@depl_id

end

go
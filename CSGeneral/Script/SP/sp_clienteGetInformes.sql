if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_clienteGetInformes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_clienteGetInformes]

/*

 select * from proveedor where cli_codigo like '300%'
 select * from documento

 sp_clienteGetInformes 35639

*/

go
create procedure sp_clienteGetInformes (
	@@cli_id 		int
)
as

begin

	set nocount on

	declare @us_id int

	select @us_id = us_id from cliente where cli_id = @@cli_id

	select 
					per_id,
					inf_id,
					inf_nombre,
					inf_codigo,
					inf.pre_id

	from informe inf inner join permiso per on inf.pre_id = per.pre_id

	where us_id = @us_id

end

go
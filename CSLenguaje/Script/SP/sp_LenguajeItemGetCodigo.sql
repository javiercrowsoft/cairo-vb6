if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_LenguajeItemGetCodigo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_LenguajeItemGetCodigo]

/*

 sp_LenguajeItemGetCodigo 

*/

go
create procedure sp_LenguajeItemGetCodigo 

as

begin

	set nocount on

	create table #t_lenguajeItem (lengi_codigo int not null)

	if exists (select * from LenguajeItem where isnumeric(lengi_codigo) <> 0)
	begin

		insert into #t_lenguajeItem (lengi_codigo) select lengi_codigo from LenguajeItem where isnumeric(lengi_codigo) <> 0

		select max(lengi_codigo)+1 from #t_lenguajeItem		

	end else begin

		select 1001

	end


end

go
/*---------------------------------------------------------------------
Nombre: Lista informes que tienen mal definidos sus parametros
---------------------------------------------------------------------*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[DC_CSC_SYS_0110]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[DC_CSC_SYS_0110]

/*

 DC_CSC_SYS_0110 1

*/

go
create procedure DC_CSC_SYS_0110 (

  @@us_id          int

)as 
begin
set nocount on

	select 	inf.inf_id, 
					inf_codigo																					 as Codigo,
					inf_storedprocedure																	 as SP,
					inf_nombre																					 as Nombre,
					count(infp.inf_id)+1																 as [Params Inf],
					(select count(name) from syscolumns where id = s.id) as [Params SP]

	from sysobjects s inner join informe inf on s.name = inf.inf_storedprocedure
	                  left join informeparametro infp on inf.inf_id = infp.inf_id
	group by 
		inf.inf_id, 
		inf_codigo,
		inf_storedprocedure,
		inf_nombre,
		s.id 

	having count(infp.inf_id)+1 <> (select count(name) from syscolumns where id = s.id)
	order by inf_codigo

end
go
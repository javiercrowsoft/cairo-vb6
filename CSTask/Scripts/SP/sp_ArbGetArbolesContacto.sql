if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbGetArbolesContacto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbGetArbolesContacto]

go

/*

exec sp_ArbGetArbolesContacto 447, 2001

*/

create procedure sp_ArbGetArbolesContacto (
	@@us_id int,
	@@tbl_id int
)
as
begin

set nocount on
if not exists(select 
												Arbol.arb_id,
												arb_Nombre,
												ram_id 
							
							from Arbol inner join Rama on Arbol.arb_id = Rama.arb_id 
							
							where ram_id_padre = 0  
								and tbl_id 			 = @@tbl_id 
								and ram_id 			<> 0
								and Arbol.modifico = @@us_id
				) begin

	declare @us_nombre varchar(255)

	select @us_nombre = us_nombre from usuario where us_id = @@us_id

	set @us_nombre= 'Contactos - ' + @us_nombre

	exec sp_ArbAddArbol @@us_id, @@tbl_id, @us_nombre

end

--////////////////////////////////////////////////////////////////////////////////
select 
					Arbol.arb_id,
					arb_Nombre,
					ram_id 

from Arbol inner join Rama on Arbol.arb_id = Rama.arb_id 

where ram_id_padre = 0  
	and tbl_id 			 = @@tbl_id 
	and ram_id 			<> 0
	and (Arbol.modifico = @@us_id or Arbol.Modifico = 1)

end
go

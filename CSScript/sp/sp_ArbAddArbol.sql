if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbAddArbol]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbAddArbol]

go
create procedure sp_ArbAddArbol (
	@@us_id  			int,
	@@tbl_id 			int,
  @@arb_nombre 	varchar(255)
)
as

	declare @arb_id int
  declare @ram_id int

	exec sp_dbgetnewid 'Arbol','arb_id',@arb_id out, 0

	insert into Arbol (arb_id, tbl_id, arb_nombre, modifico)
  					 values (@arb_id, @@tbl_id, @@arb_nombre, @@us_id)

	exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0

	insert into Rama (arb_id, ram_id, ram_nombre, ram_id_padre, modifico) 
						values (@arb_id, @ram_id, @@arb_nombre, 0, @@us_id)
go
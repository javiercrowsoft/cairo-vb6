if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ProveedorCreateTreeGeneral]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ProveedorCreateTreeGeneral]

go
/*
'-----------------------------------------------------------------------------------------
' Autor:    Javier
' Archivo:  MUR_ProveedorCreateTreeGeneral.sql
' Objetivo: .
'-----------------------------------------------------------------------------------------
*/

/*

*/
create Procedure MUR_ProveedorCreateTreeGeneral (
	@@arb_id		int,
	@@raiz 			int out
)
as
begin

	declare @ram_id  int

	-- proveedors de La Europea:
	--
	declare c_prov insensitive cursor for 
	select prov_id, '@@nosubfolder@@'
	from proveedor prov
	where 
				
		not exists(select * from hoja where arb_id = @@arb_id and id = prov_id)
	
	order by prov_codigo
	
	if not exists(select ram_id from rama where ram_nombre = 'General' and ram_id_padre = @@raiz) begin
			exec sp_dbgetnewid 'Rama','ram_id',@ram_id out, 0
			insert into Rama (ram_id,arb_id,ram_nombre,modifico,ram_id_padre,ram_orden)values(@ram_id,@@arb_id,'General',1,@@raiz,1000)
			select @@raiz = @ram_id
	end else select @@raiz = ram_id from rama where ram_nombre = 'General' and ram_id_padre = @@raiz

end
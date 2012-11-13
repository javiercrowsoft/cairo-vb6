if exists (select * from sysobjects where id = object_id(N'[dbo].[SP_ArbGetArboles]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[SP_ArbGetArboles]

go
create procedure sp_ArbGetArboles (
	@@tbl_id int
)
as


select Arbol.arb_Id,arb_Nombre,ram_id from 
Arbol,Rama where Rama.ram_id_padre = 0  AND Arbol.arb_Id = Rama.arb_Id AND tbl_id = @@tbl_id AND Rama.ram_id <> 0

go
if exists (select * from sysobjects where id = object_id(N'[dbo].[MUR_ProductoEmbalaje]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[MUR_ProductoEmbalaje]

/*

 MUR_ProductoEmbalaje 

  select * from producto where embl_id is not null

*/

go
create procedure MUR_ProductoEmbalaje 
as

begin

  set nocount on

  update Producto set embl_id = Embalaje.embl_id from Embalaje where Embalaje.embl_codigo = Producto.pr_MUR_Embalaje

end
go
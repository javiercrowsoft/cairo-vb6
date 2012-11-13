if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPermisoEmbarqueFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPermisoEmbarqueFirmar]

go

/*

sp_DocPermisoEmbarqueFirmar 17,8

*/

create procedure sp_DocPermisoEmbarqueFirmar (
	@@pemb_id int,
  @@us_id int
)
as

begin

  -- Si esta firmado le quita la firma
	if exists(select pemb_firmado from PermisoEmbarque where pemb_id = @@pemb_id and pemb_firmado <> 0)
		update PermisoEmbarque set pemb_firmado = 0 where pemb_id = @@pemb_id
	-- Sino lo firma
	else
		update PermisoEmbarque set pemb_firmado = @@us_id where pemb_id = @@pemb_id

	exec sp_DocPermisoEmbarqueSetEstado @@pemb_id

	select PermisoEmbarque.est_id,est_nombre 
	from PermisoEmbarque inner join Estado on PermisoEmbarque.est_id = Estado.est_id
	where pemb_id = @@pemb_id
end
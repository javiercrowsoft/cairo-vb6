if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocManifiestoCargaFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocManifiestoCargaFirmar]

go

/*

sp_DocManifiestoCargaFirmar 17,8

*/

create procedure sp_DocManifiestoCargaFirmar (
	@@mfc_id int,
  @@us_id int
)
as

begin

  -- Si esta firmado le quita la firma
	if exists(select mfc_firmado from ManifiestoCarga where mfc_id = @@mfc_id and mfc_firmado <> 0)
		update ManifiestoCarga set mfc_firmado = 0 where mfc_id = @@mfc_id
	-- Sino lo firma
	else
		update ManifiestoCarga set mfc_firmado = @@us_id where mfc_id = @@mfc_id

	exec sp_DocManifiestoCargaSetEstado @@mfc_id

	select ManifiestoCarga.est_id,est_nombre 
	from ManifiestoCarga inner join Estado on ManifiestoCarga.est_id = Estado.est_id
	where mfc_id = @@mfc_id
end
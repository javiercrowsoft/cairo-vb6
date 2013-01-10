if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_DocPackingListFirmar]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_DocPackingListFirmar]

go

/*

sp_DocPackingListFirmar 17,8

*/

create procedure sp_DocPackingListFirmar (
  @@pklst_id int,
  @@us_id int
)
as

begin

  -- Si esta firmado le quita la firma
  if exists(select pklst_firmado from PackingList where pklst_id = @@pklst_id and pklst_firmado <> 0)
    update PackingList set pklst_firmado = 0 where pklst_id = @@pklst_id
  -- Sino lo firma
  else
    update PackingList set pklst_firmado = @@us_id where pklst_id = @@pklst_id

  exec sp_DocPackingListSetEstado @@pklst_id

  select PackingList.est_id,est_nombre 
  from PackingList inner join Estado on PackingList.est_id = Estado.est_id
  where pklst_id = @@pklst_id
end
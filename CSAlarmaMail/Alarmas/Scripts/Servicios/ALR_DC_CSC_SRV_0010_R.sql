/*
  Facturas con mas de 30 dias de vencidas
*/
if exists (select * from sysobjects where id = object_id(N'[dbo].[ALR_DC_CSC_SRV_0010_R]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[ALR_DC_CSC_SRV_0010_R]
go

/*

ALR_DC_CSC_SRV_0010_R

*/

create procedure ALR_DC_CSC_SRV_0010_R (

  @@almr_id_mail int,
  @@mail_id      int,
  @@maili_id     int
) 
as 
begin

  set nocount on

  declare @alm_id int
  set @alm_id = 2

  insert AlarmaMailResult (alm_id, almr_id_mail) values (@alm_id, @@almr_id_mail)

end

go
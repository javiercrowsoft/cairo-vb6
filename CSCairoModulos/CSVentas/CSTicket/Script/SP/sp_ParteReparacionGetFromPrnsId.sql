if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ParteReparacionGetFromPrnsId]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ParteReparacionGetFromPrnsId]

go

create procedure sp_ParteReparacionGetFromPrnsId (
  @@prns_id       int
)
as
begin

  set nocount on

  select prp_id from ParteReparacion where prns_id = @@prns_id

end
if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbVistaSaveItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbVistaSaveItem]

go
create procedure sp_ArbVistaSaveItem (
  @@arbv_id         int,
  @@ram_id          int,
  @@ramv_estado      tinyint
)
as

set nocount on

begin

  declare @ramv_id int

  exec sp_dbgetnewid 'RamaVista', 'ramv_id', @ramv_id out, 0

  insert into RamaVista (arbv_id, ramv_id, ram_id, ramv_estado)
              values    (@@arbv_id, @ramv_id, @@ram_id, @@ramv_estado)

end


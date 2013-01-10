if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_RetencionGetByPorcentaje]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_RetencionGetByPorcentaje]

/*

*/

go
create procedure sp_RetencionGetByPorcentaje (
  @@rett_id int,
  @@porc    decimal(18,6)
)
as

begin

  select ret.ret_id
  from Retencion ret inner join RetencionItem reti on ret.ret_id = reti.ret_id
  where (rett_id = @@rett_id or ret_esiibb <> 0)
    and reti_porcentaje = @@porc

end

go
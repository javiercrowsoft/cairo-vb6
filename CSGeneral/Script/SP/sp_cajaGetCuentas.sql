if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_cajaGetCuentas]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_cajaGetCuentas]

/*

*/

go
create procedure sp_cajaGetCuentas (
  @@cj_id int
)
as

begin

  set nocount on

  select cjc.*, 
         cuet.cue_nombre as cue_trabajo,
         cuef.cue_nombre as cue_fondos

  from CajaCuenta cjc inner join Cuenta cuet on cjc.cue_id_trabajo = cuet.cue_id 
                      inner join Cuenta cuef on cjc.cue_id_fondos  = cuef.cue_id

  where cjc.cj_id = @@cj_id

end

go
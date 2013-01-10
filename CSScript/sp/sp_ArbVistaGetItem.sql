if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ArbVistaGetItems]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ArbVistaGetItems]

go
create procedure sp_ArbVistaGetItems (
  @@arbv_id         int
)
as

set nocount on

begin

  select r.ram_id,
         ramv_estado

  from ArbolVista av   inner join Rama r     on av.arb_id = r.arb_id
                       left join RamaVista v on r.ram_id = v.ram_id
                                              and av.arbv_id = v.arbv_id
  where av.arbv_id = @@arbv_id
  order by ram_orden
end


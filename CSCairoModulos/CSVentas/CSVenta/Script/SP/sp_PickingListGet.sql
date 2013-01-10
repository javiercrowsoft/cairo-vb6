if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_PickingListGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_PickingListGet]

go

create procedure sp_PickingListGet (
  @@pkl_id int
)
as

begin


  select 
          pkl.*,
          suc_nombre

  from 
  
      PickingList pkl   inner join sucursal suc    on pkl.suc_id      = suc.suc_id

  
  where 
        pkl.pkl_id = @@pkl_id
  
end

go
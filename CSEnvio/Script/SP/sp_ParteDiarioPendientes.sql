if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ParteDiarioPendientes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ParteDiarioPendientes]

go
/*
delete aviso where avt_id = 2

sp_ParteDiarioPendientes 

*/
create procedure sp_ParteDiarioPendientes 
as

begin

  set nocount on

  declare @av_id      int
  declare @av_descrip  varchar(255)
  declare @id          varchar(255)
  declare @us_id       int

  declare c_PartesPendientes insensitive cursor for
  select ptd_id,ptd_titulo,us_id_responsable from partediario 
       where ptd_cumplida = 1 -- Pendiente
        and  not exists(select id from aviso where avt_id = 2 and id = ptd_id)
        and  ptd_alarma <= getdate()

  open c_PartesPendientes

  fetch next from c_PartesPendientes into @id,@av_descrip,@us_id
  while @@fetch_status = 0 begin

    exec SP_DBGetNewId 'Aviso','av_id',@av_id out
    insert into aviso (av_id,  av_descrip, id, av_leido, avt_id, us_id, modifico, activo)
                values(@av_id,@av_descrip,@id,0,2,@us_id,@us_id,1)
    
    fetch next from c_PartesPendientes into @id,@av_descrip,@us_id
  end   
  close c_PartesPendientes
  deallocate c_PartesPendientes

  -- Si ya no esta pendiente lo borro
  delete aviso where avt_id = 2 and not exists(select ptd_id from partediario where ptd_id = id and ptd_cumplida = 1)

end

go
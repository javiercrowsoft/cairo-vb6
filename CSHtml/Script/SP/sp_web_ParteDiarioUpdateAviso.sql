if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_web_ParteDiarioUpdateAviso]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ParteDiarioUpdateAviso]

go
create procedure sp_web_ParteDiarioUpdateAviso (
  @@ptd_id                       int
)
as

begin

  set nocount on

  declare @sqlstmt             varchar(5000)
  declare @ptd_listausuarios   varchar(5000)
  declare @us_id               int
  declare @av_id               int
  declare @modifico            int

  select @ptd_listausuarios = ptd_listausuariosid, 
         @modifico = modifico 
  from ParteDiario where ptd_id = @@ptd_id

  declare @clientId datetime
  set @clientId = getdate()
  exec sp_strStringToTable @clientId, @ptd_listausuarios, ', '

  declare c_usuarios insensitive cursor for
  select us_id from usuario where us_id in (select tmpstr2tbl_campo from TmpStringToTable where tmpstr2tbl_id = @clientId)
  
  open c_usuarios

  fetch next from c_usuarios into @us_id
  while @@fetch_status=0 begin

    if not exists(select * from Aviso where avt_id = 1 and us_id = @us_id and id = @@ptd_id)
    begin
    
      exec sp_dbgetnewid 'Aviso','av_id',@av_id out,0 
      insert into Aviso (
                          av_id,
                          av_descrip,
                          id,
                          av_leido,
                          avt_id,
                          us_id,
                          modifico
                        )
                values (
                          @av_id,
                          '',
                          @@ptd_id,
                          0,
                          1, /* Parte Diario */
                          @us_id,
                          @modifico
                        )
    end else begin

      update Aviso set av_leido = 0 where avt_id = 1 and us_id = @us_id and id = @@ptd_id

    end    

    fetch next from c_usuarios into @us_id
  end

  close c_usuarios
  deallocate c_usuarios
end
GO
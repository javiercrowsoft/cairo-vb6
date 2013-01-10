if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_srv_cvxi_isnewemail]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_srv_cvxi_isnewemail]

go
/*

*/

create procedure sp_srv_cvxi_isnewemail (

  @@cmiea_id    int,
  @@mail_id     varchar(255),
  @@cmie_date   datetime

)

as

begin

  set nocount on

  declare @cmie_id int

  -- Si el mail esta pero no esta el body asumo que es nuevo
  -- esto es para resolver cualquier mail al que le he bajado
  -- el header pero no el body
  --
  select @cmie_id = cmie_id  
  from ComunidadInternetMail 
  where cmie_mailid = @@mail_id 
    and cmie_body_updated <> 0 
    and cmiea_id = @@cmiea_id
    and cmie_date = @@cmie_date

  if @cmie_id is not null begin

    select 0  as is_new, @cmie_id as cmie_id

  end else begin

    select 1  as is_new, 0 as cmie_id

  end

end
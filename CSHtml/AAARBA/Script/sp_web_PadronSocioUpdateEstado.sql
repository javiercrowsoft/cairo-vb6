SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_PadronSocioUpdateEstado]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_PadronSocioUpdateEstado]
GO

create procedure sp_web_PadronSocioUpdateEstado (
  @@est_id_cont   int,
  @@est_id_sec    int,
  @@pad_id        int,
  @@us_id          int
)
as

begin

  set nocount on

  if @@est_id_cont <> 0 update aaarbaweb..PadronSocio 
                              set est_id_cont         = @@est_id_cont,
                                  us_id_contaduria    = @@us_id,
                                  modificado_sag_cont  = getdate()
                              where pad_id = @@pad_id

  if @@est_id_sec  <> 0 update aaarbaweb..PadronSocio 
                              set est_id_sec          = @@est_id_sec,
                                  us_id_secretaria    = @@us_id,
                                  modificado_sag_sec  = getdate()
                              where pad_id = @@pad_id

  if exists(select * from aaarbaweb..PadronSocio where est_id_cont = 5 and est_id_sec = 5 and pad_id = @@pad_id)
  begin

    update aaarbaweb..PadronSocio set est_id = 5 where pad_id = @@pad_id

  end

end

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_EncuestaUpdateVoto]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_EncuestaUpdateVoto]
GO

/*

*/

create Procedure sp_web_EncuestaUpdateVoto (
     @@ecpi_id              int,
    @@ecr_infoAdicional    varchar(255),
    @@us_id                int
) 
as

  declare @ecr_id int

  if @@ecr_infoAdicional is null set @@ecr_infoAdicional = ''

  declare @ecp_id         int
  declare @ecp_multiple    tinyint

  select @ecp_id = ecp_id from EncuestaPreguntaItem where ecpi_id = @@ecpi_id

  select @ecp_multiple = ecp_multiple from EncuestaPregunta where ecp_id = @ecp_id

  declare @puede_votar tinyint

  if @ecp_multiple <> 0 begin

    if not exists(select * from EncuestaRespuesta where ecpi_id = @@ecpi_id and us_id = @@us_id)
      set @puede_votar = 1
    else
      set @puede_votar = 0
  end
  else begin

    if not exists(select * 
                  from EncuestaRespuesta ecr 
                        inner join EncuestaPreguntaItem ecpi 
                            on ecr.ecpi_id = ecpi.ecpi_id
                  where ecp_id = @ecp_id and us_id = @@us_id)
      set @puede_votar = 1
    else
      set @puede_votar = 0

  end
  



  -- Para que un mismo usuario no vote dos veces
  -- por la misma opcion
  --
  if @puede_votar <> 0
  begin

    exec SP_DBGetNewId 'EncuestaRespuesta', 'ecr_id', @ecr_id out, 0
    
    insert into EncuestaRespuesta (
                              ecr_id,
                              ecpi_id,
                              ecr_infoAdicional,
                              us_id  
                            )
                    values  (
                              @ecr_id,
                              @@ecpi_id,
                              @@ecr_infoAdicional,
                              @@us_id
                            )
  end

go
set quoted_identifier off 
go
set ansi_nulls on 
go


if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_embarqueGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_embarqueGet]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_embarqueGet 2

create procedure sp_embarqueGet (
  @@emb_id  int
)
as

set nocount on

begin

 select
    Embarque.*,
    origen.pue_nombre   as [Puerto origen],
    destino.pue_nombre  as [Puerto destino],
    barc_nombre         
 from
 
 Embarque left join Puerto as origen        on Embarque.pue_id_origen  = origen.pue_id
          left join Puerto as destino        on Embarque.pue_id_destino = destino.pue_id
          left join Barco                   on Embarque.barc_id        = Barco.barc_id

 where
     emb_id = @@emb_id

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go




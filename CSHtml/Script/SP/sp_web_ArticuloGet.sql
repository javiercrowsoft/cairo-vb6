SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_ArticuloGet]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ArticuloGet]
GO

/*

sp_web_ArticuloGet 7

*/

create Procedure sp_web_ArticuloGet
(
  @@us_id int  
) 
as

  select 
      wart_id,
      wart_titulo               as [Titulo], 
      wart_copete               as [Copete],
      wart_origen               as [Origen],
      wart_origenurl            as [Origen URL],
      wart_imagen                as [Imagen],
      wart_fecha                as [Fecha],
      wartt_nombre               as [Tipo],
      warte_nombre               as [Estado]

  from webArticulo a inner join webArticuloTipo  t            on a.wartt_id = t.wartt_id
                     inner join webArticuloEstado  e          on a.warte_id = e.warte_id
--   where 
-- 
--            (  -- Noticias donde este usuario tiene permisos
--             exists(select us_id from webArticuloUsuario where us_id = @@us_id and wart_id = a.wart_id) 
--         or 
--             a.warte_id = 2 -- Noticias publicas
--           )
  order by Fecha desc 

go
set quoted_identifier off 
go
set ansi_nulls on 
go


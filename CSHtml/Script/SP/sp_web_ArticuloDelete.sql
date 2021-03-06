SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[sp_web_ArticuloDelete]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_web_ArticuloDelete]
GO

/*
select * from webarticulo
sp_web_ArticuloDelete 1,10,0

*/

create Procedure sp_web_ArticuloDelete
(
  @@us_id     int,
  @@wart_id   int,
  @@rtn       int out
) 
as

  /* select tbl_id,tbl_nombrefisico from tabla where tbl_nombrefisico like '%%'*/
  declare @wart_titulo varchar (255)
  select @wart_titulo = wart_titulo from webArticulo where wart_id = @@wart_id
  exec sp_HistoriaUpdate 25000, @@wart_id, @@us_id, 4, @wart_titulo

  delete webArticulo where wart_id = @@wart_id 

  set @@rtn = 1
go
set quoted_identifier off 
go
set ansi_nulls on 
go


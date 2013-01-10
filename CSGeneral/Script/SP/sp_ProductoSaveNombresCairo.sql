if exists (select * from sysobjects where id = object_id(N'[dbo].[sp_ProductoSaveNombresCairo]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[sp_ProductoSaveNombresCairo]

go

set quoted_identifier on 
go
set ansi_nulls on 
go

-- sp_ProductoSaveNombresCairo 1,135

-- select rpt_id_nombrecompra,* from producto where rpt_id_nombrecompra is not null

-- DC_CSC_VEN_9700 1,135,1,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- DC_CSC_VEN_9700 1,135,0,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- DC_CSC_VEN_9700 1,135,0,'prefjio',0,0,0,0,0,1,2,3,4,3,'s1',4,'s2',1,'s3',2,'s4',6,'s5',7,'s6',9,'s7',5,'s8',8,'s9',10,'s10'
-- Cartucho HP Negro Carga Completa Orignial Toner Laser

create procedure sp_ProductoSaveNombresCairo (
  @@us_id int,
  @@pr_id  int
)
as

set nocount on

begin

  set @@us_id = @@us_id*-1

  declare @sqlstmt               varchar(5000)
  declare @param                varchar(255)
  declare @param_tipo           tinyint
  declare @inf_id                int
  declare @rpt_id_nombrecompra   int
  declare @rpt_id_nombreventa   int
  declare @rpt_id_nombrefactura  int
  declare @rpt_id_nombreweb     int
  declare @rpt_id_nombreimg     int
  declare @rpt_id_nombreimgalt  int

  select 
          @rpt_id_nombrecompra   = rpt_id_nombrecompra,
          @rpt_id_nombreventa   = rpt_id_nombreventa,
          @rpt_id_nombrefactura = rpt_id_nombrefactura,
          @rpt_id_nombreweb     = rpt_id_nombreweb,
          @rpt_id_nombreimg     = rpt_id_nombreimg,
          @rpt_id_nombreimgalt   = rpt_id_nombreimgalt

  from Producto where pr_id = @@pr_id

  if @rpt_id_nombrecompra is not null begin

    exec sp_ProductoSaveNombresAux @@us_id, @@pr_id, @rpt_id_nombrecompra

  end

  if @rpt_id_nombreventa is not null begin

    exec sp_ProductoSaveNombresAux @@us_id, @@pr_id, @rpt_id_nombreventa

  end

  if @rpt_id_nombrefactura is not null begin

    exec sp_ProductoSaveNombresAux @@us_id, @@pr_id, @rpt_id_nombrefactura

  end

  if @rpt_id_nombreweb is not null begin

    exec sp_ProductoSaveNombresAux @@us_id, @@pr_id, @rpt_id_nombreweb

  end

  if @rpt_id_nombreimg is not null begin

    exec sp_ProductoSaveNombresAux @@us_id, @@pr_id, @rpt_id_nombreimg

  end

  if @rpt_id_nombreimgalt is not null begin

    exec sp_ProductoSaveNombresAux @@us_id, @@pr_id, @rpt_id_nombreimgalt

  end

end

go
set quoted_identifier off 
go
set ansi_nulls on 
go



